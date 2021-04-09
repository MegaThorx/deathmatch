import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../Stores/store';

interface OneColumnProps {
}

const OneColumn: FC<OneColumnProps> = () => {
	const state = useSelector((state: RootState) => state.Scoreboard);

	
	const rows = [...(state.players)]
		.sort((a, b) => {
			var aField: any = a.data[state.config.sortBy] ? a.data[state.config.sortBy] : '';
			var bField: any = b.data[state.config.sortBy] ? b.data[state.config.sortBy] : '';

			if (state.config.sortDirection === 'ASC') {
				return aField > bField ? 1 : -1;
			}

			if (!isNaN(Number(aField))) {
				aField = Number(aField);
			}

			if (!isNaN(Number(bField))) {
				bField = Number(bField);
			}


			return aField > bField ? -1 : 1;
		})
		.map((player) => 
			<tr key={player.name}>
				<td>{player.name}</td>
				{state.config.columns.map((column) => {
					let value = typeof player.data[column.name] !== 'undefined' ? player.data[column.name] : '-';
					
					return <td key={column.name}>{value}</td>;
				})}
				<td>{player.ping}</td>
			</tr>
		);


    return (
        <table className="Scoreboard-scores">
            <thead>
                <tr>
                    <th>Name</th>
                    {state.config.columns.map((column) => {
                        return <th key={column.name}>{column.name}</th>;
                    })}
                    <th>Ping</th>
                </tr>
            </thead>
            <tbody>
                {rows}
            </tbody>
        </table>
	  );
};

export default OneColumn;
